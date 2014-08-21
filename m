From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH/RFC V2 07/16] scsi: support well known logical units
Date: Thu, 21 Aug 2014 17:18:53 -0400
Message-ID: <yq1fvgpr16q.fsf@sermon.lab.mkp.net>
References: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
	<1408023067-26103-8-git-send-email-draviv@codeaurora.org>
	<20140819172251.GA12892@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140819172251.GA12892@infradead.org> (Christoph Hellwig's
	message of "Tue, 19 Aug 2014 12:22:51 -0500")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dolev Raviv <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> + /*
>> + * put runtime pm reference for well-known logical units,
>> + * drivers are expected to _get_* again during probe.
>> + */
>> + if (scsi_is_wlun(sdev->lun))
>> + scsi_autopm_put_device(sdev);

Christoph> Special casing the well known LUNs here seems wrong.
Christoph> Shouldn't we do this for any devices that don't get a driver
Christoph> attached to them?

That would also be my preference. Relying on WLU for this seems like a
kludge.

-- 
Martin K. Petersen	Oracle Linux Engineering
