From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 4/4] scsi: hisi_sas: Add support for DIF feature for v3
 hw
Date: Wed, 5 Dec 2018 15:12:27 +0000
Message-ID: <9c08d3fa-5043-7d38-7b6c-574b7344409b@huawei.com>
References: <1543838994-30028-1-git-send-email-john.garry@huawei.com>
 <1543838994-30028-5-git-send-email-john.garry@huawei.com>
 <yq1ftveszew.fsf@oracle.com>
 <358aae82-394e-9df2-6b05-5af8e0f196b3@huawei.com>
 <yq1k1kosorw.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1k1kosorw.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 05/12/2018 02:14, Martin K. Petersen wrote:
>
> John,

Hi Martin,

>
>> Are you happy for us to make DIX support in this driver "hisi_sas DIX
>> experimental" short term?
>
> That's entirely your call, it's your driver/controller.  I just want the
> experimental tag to be due to reasons on *your* end.
>

Well unfortunately at the moment we cannot definitively say that it is 
an issue on our end. There's a reasonable chance it is.

> If it's reasons on my end they'll need to get fixed. We shouldn't have
> drivers circumventing features because of bugs in the core block/SCSI
> code...
>

Right, of course not. I'm just a bit stuck now, since we need to 
upstream the DIF support ASAP, but it is being held back by the DIX support.

You did request not to throw away DIX support, so I can send a new 
patchset with DIF and DIX support separated out, and we can leave the 
DIX patch in limbo until we get to the bottom of the DIX issue.

I hope it's ok.

Thanks,
John
