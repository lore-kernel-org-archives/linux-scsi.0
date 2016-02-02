From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v7 02/14] scsi: ufs: clear fields UTRD, UPIU req and rsp
 before new transfers
Date: Tue, 2 Feb 2016 10:07:26 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B54164238@hasmsx108.ger.corp.intel.com>
References: <1454331770-29642-1-git-send-email-ygardi@codeaurora.org>
 <1454331770-29642-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1454331770-29642-3-git-send-email-ygardi@codeaurora.org>
Content-Language: en-US
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, "robherring2@gmail.com" <robherring2@gmail.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "pebolle@tiscali.nl" <pebolle@tiscali.nl>, "hch@infradead.org" <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "santoshsy@gmail.com" <santoshsy@gmail.com>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "gbroner@codeaurora.org" <gbroner@codeaurora.org>, "draviv@codeaurora.org" <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org



> Some of the data structures (like response UPIU) and/or its elements
> (unused fields) should be cleared before sending out the respective
> command to UFS device.
> 
> This change clears the UPIU response data structure for query commands
> and NOP command before sending out the command. We also initialize the
> PRDT table length to zero which should take care of commands which doesn't
> have any data associated with it. We are also clearing the unused fields in
> request UPIU for NOP command.
> 
> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
> Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>


You can add my ack and/or tested by (we have similar fix running in our code base for a long time :))

Thanks
Tomas
