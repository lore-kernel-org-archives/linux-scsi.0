From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 00/11] Updates for scsi-next
Date: Fri, 2 Dec 2016 15:40:07 +0100
Message-ID: <427adff7-c6ce-257c-7e6b-3925b0aaff61@redhat.com>
References: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, sumit.saxena@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 2.12.2016 15:07, Sasikumar Chandrasekaran wrote:
> Sasikumar Chandrasekaran (11):
>   megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid
>     Controllers
>   megaraid_sas: 128 MSIX Support
>   megaraid_sas: EEDP Escape Mode Support for SAS3.5 Generic Megaraid
>     Controllers
>   megaraid_sas: SAS3.5 Generic Megaraid Controllers Stream Detection and
>     IO Coalescing
>   megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID
>     1/10 Writes
>   megaraid_sas: Dynamic Raid Map Changes for SAS3.5 Generic Megaraid
>     Controllers
>   megaraid_sas: Add the Support for SAS3.5 Generic Megaraid Controllers
>     Capabilities
>   megaraid_sas: Enable or Disable Fast path based on the PCI Threshold
>     Bandwidth
>   megaraid_sas: ldio_outstanding variable is not decremented in
>     completion path
>   megaraid_sas: Implement the PD Map support for SAS3.5 Generic Megaraid
>     Controllers
>   megaraid_sas: driver version upgrade
>
>  drivers/scsi/megaraid/megaraid_sas.h        | 139 ++++--
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 242 +++++++---
>  drivers/scsi/megaraid/megaraid_sas_fp.c     | 319 +++++++++++--
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 687 ++++++++++++++++++++++++----
>  drivers/scsi/megaraid/megaraid_sas_fusion.h | 318 ++++++++++++-
>  5 files changed, 1474 insertions(+), 231 deletions(-)
>
Hi Sasikumar,

pleas run the scripts/checkpatch.pl script on your patch before sending,
it shows errors like this one

ERROR: DOS line endings
#80: FILE: drivers/scsi/megaraid/megaraid_sas.h:59:
+#define PCI_DEVICE_ID_LSI_MECTOR^I^I    0x00D4^M$

>From my point of view there are too many checkpatch issues and the series
should be fixed.

Also when you resend the series add a version counting string V2 , V3 ...
to the mail subject so -> "[PATCH V2 00/11] Updates for scsi-next"


Thanks,
Tomas
