From: walt <w41ter@gmail.com>
Subject: Re: [PATCH v2] scsi: fix async probe regression
Date: Tue, 29 May 2012 17:53:02 -0700
Message-ID: <jq3r1h$p37$1@dough.gmane.org>
References: <20120525175140.22423.21697.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120525175140.22423.21697.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/25/2012 10:55 AM, Dan Williams wrote:
> Commit a7a20d1 "[SCSI] sd: limit the scope of the async probe domain"
> moved sd probe work out of reach of wait_for_device_probe().  Allow it
> to be synced via scsi_complete_async_scans().

Hi Dan.  After applying version 2 of a7a20d1 I can boot again, but there's
a catch :)

My grub.cfg boot menu entry uses the root=PARTUUID=<guid> syntax, but that
has stopped working.  After a7a20d1(v2) I have to use root=/dev/sda5 or I
get the familiar "can't find block device (foo,bar)" kernel panic.

Any idea what would cause that particular kind of breakage?

Thanks!
