From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BUG] scsi: ses: out of bound accessing in ses_enclosure_data_process
Date: Mon, 18 Mar 2019 01:01:58 -0400
Message-ID: <yq1k1gwkc6x.fsf@oracle.com>
References: <78dd3eca-7e8a-72f9-07f9-e2c7cc4569b0@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <78dd3eca-7e8a-72f9-07f9-e2c7cc4569b0@oracle.com> (jianchao
        wang's message of "Thu, 14 Mar 2019 11:19:31 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, diego.gonzalez@oracle.com
List-Id: linux-scsi@vger.kernel.org


Jianchao,

> When our customer probe the lpfc devices, they encountered odd memory
> corruption issues, and we get 'out of bound' access warning at
> following position after open KASAN

Please provide the output of:

# sg_ses -p 1 /dev/sgN
# sg_ses -p 7 /dev/sgN

for the enclosure device in question.

-- 
Martin K. Petersen	Oracle Linux Engineering
