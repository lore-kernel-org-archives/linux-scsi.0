From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [BUG] scsi: ses: out of bound accessing in
 ses_enclosure_data_process
Date: Mon, 18 Mar 2019 13:09:58 +0800
Message-ID: <5cc39d77-4a88-1449-6d5a-c0735db63dfb@oracle.com>
References: <78dd3eca-7e8a-72f9-07f9-e2c7cc4569b0@oracle.com>
 <yq1k1gwkc6x.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1k1gwkc6x.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.ibm.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, diego.gonzalez@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi Martin

Thanks for your kindly response.

On 3/18/19 1:01 PM, Martin K. Petersen wrote:
> 
> Jianchao,
> 
>> When our customer probe the lpfc devices, they encountered odd memory
>> corruption issues, and we get 'out of bound' access warning at
>> following position after open KASAN
> 
> Please provide the output of:
> 
> # sg_ses -p 1 /dev/sgN
> # sg_ses -p 7 /dev/sgN
> 
> for the enclosure device in question.

OK, I will send this to customer.
And share the result here after get feedback.

Thanks
Jianchao
