From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] mptfusion: enable no_write_same for vmware scsi disks
Date: Tue, 23 Sep 2014 19:28:04 -0400
Message-ID: <yq14mvxudbv.fsf@sermon.lab.mkp.net>
References: <20140923071154.GB3867@infradead.org>
	<1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
	<5421F020.1030309@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5421F020.1030309@canonical.com> (Chris J. Arges's message of
	"Tue, 23 Sep 2014 17:11:44 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: hch@infradead.org, bruce.lucas@mongodb.com, adam.radford@avagotech.com, kashyap.desai@avagotech.com, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chris" == Chris J Arges <chris.j.arges@canonical.com> writes:

Chris> 1) Does this workaround make sense? Perhaps there is an easier
Chris>    way?

One option is to ship a udev rule that disables write same on VMware
disks. However, I don't have a fundamental problem having a workaround
for this in the kernel.

Chris> 2) Do we expect changing max_write_same_blocks at the scsi_disk
Chris>    level to propagate the right write_same flags to other layers
Chris>    such as dm?

No, there's currently no way to communicate that the underlying topology
has changed.

-- 
Martin K. Petersen	Oracle Linux Engineering
