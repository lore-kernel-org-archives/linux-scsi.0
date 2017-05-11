From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] target/iscsi: make function target_parse_xcopy_cmd static
Date: Thu, 11 May 2017 14:58:26 +0100
Message-ID: <6e670a58-8efc-72ff-4e0f-ff36541b7026@canonical.com>
References: <20170511101616.19790-1-colin.king@canonical.com>
 <1494510957.3018.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494510957.3018.1.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/05/17 14:55, Bart Van Assche wrote:
> On Thu, 2017-05-11 at 11:16 +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Making target_parse_xcopy_cmd static fixes sparse warning:
>>
>> "warning: symbol 'target_parse_xcopy_cmd' was not declared.  Should
>> it be static?"
>>
>> Fixes: 1bd05294519f76 ("target/iscsi: Fix a deadlock between the XCOPY code and session shutdown")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/target/target_core_xcopy.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
>> index aecb36d955f0..00e0269e6be4 100644
>> --- a/drivers/target/target_core_xcopy.c
>> +++ b/drivers/target/target_core_xcopy.c
>> @@ -886,7 +886,7 @@ static void target_xcopy_do_work(struct work_struct *work)
>>   * Returns TCM_NO_SENSE upon success or a sense code != TCM_NO_SENSE if parsing
>>   * fails.
>>   */
>> -sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
>> +static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
>>  {
>>  	struct se_cmd *se_cmd = xop->xop_se_cmd;
>>  	unsigned char *p = NULL, *seg_desc;
> 
> Hello Colin,
> 
> Thanks for the patch. I will merge it in patch "target/iscsi: Fix a deadlock between the
> XCOPY code and session shutdown".
> 
> Bart.
> 
Thanks, sounds good to me.

Colin
