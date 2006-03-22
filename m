From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 05/15] libata: Add __ata_scsi_ioctl
Date: Wed, 22 Mar 2006 18:35:29 -0500
Message-ID: <4421DF41.3000200@pobox.com>
References: <200603172304.k2HN4Stx030065@d01av02.pok.ibm.com> <4420AE54.6090603@pobox.com> <4421DC35.6090109@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4421DC35.6090109@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> Jeff Garzik wrote:
> 
>>Brian King wrote:
>>
>>> 
>>>-int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
>>>+int __ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
>>> {
>>>-	struct ata_port *ap;
>>>-	struct ata_device *dev;
>>> 	int val = -EINVAL, rc = -EINVAL;
>>> 
>>>-	ap = (struct ata_port *) &scsidev->host->hostdata[0];
>>>-	if (!ap)
>>>-		goto out;
>>>-
>>>-	dev = ata_scsi_find_dev(ap, scsidev);
>>>-	if (!dev) {
>>>-		rc = -ENODEV;
>>>-		goto out;
>>>-	}
>>>-
>>> 	switch (cmd) {
>>
>>
>>Rather than create a new function, it looks like the above code can 
>>simply be removed.  I don't see anything that uses 'ap' or 'dev'.
>>
> 
> 
> Sounds good to me. Patch below.

ACK


