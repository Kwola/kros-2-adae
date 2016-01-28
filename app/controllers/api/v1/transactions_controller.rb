module Api::V1
  class TransactionsController < BaseController
    def index
      transaction = Transaction.all
      if item_id = params[:item_id]
        transaction = Transaction.where(item_id: item_id)
      end


      render json: transaction, status: :ok
    end

    def show
      #transaction = Transaction.find(params[:id])
      transaction = Transaction.where("transactions.seller_id = #{params[:id]} OR transactions.buyer_id = #{params[:id]}")

      if !transaction.nil?
        render json: transaction
      else
        render json: {
          error: "No such transaction; check the user_id",
          status: 400
        }, status: 400
      end
    end

    def create
      transaction = Transaction.new(transaction_params)

      if transaction.save
        render nothing: true, status: 204#, location: user
      else
        render json: transaction.errors, status: 422
      end
    end

    def destroy
      transaction = Transaction.find(params[:id])

      if !transaction.nil?
        Transaction.destroy(params[:id])
        head :no_content
      else
        render json: {
          error: "No such transaction; check the transaction id",
          status: 400
        }, status: 400
      end
    end

    private

      def transaction_params
        params.require(:transactions).permit(:start_date, :end_date,
        :return_date, :item_id, :buyer_id, :out_scan, :in_scan)
      end
  end
end
