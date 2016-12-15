From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V5 00/11] megaraid_sas: Updates for scsi-next
Date: Thu, 15 Dec 2016 16:50:11 +0100
Message-ID: <944e4acd-6a9e-1a3f-debf-f6634e365ad6@redhat.com>
References: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 14.12.2016 23:12, Sasikumar Chandrasekaran wrote:
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
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 233 +++++++--
>  drivers/scsi/megaraid/megaraid_sas_fp.c     | 293 +++++++++--
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 742 +++++++++++++++++++++++-----
>  drivers/scsi/megaraid/megaraid_sas_fusion.h | 364 ++++++++++++--
>  5 files changed, 1495 insertions(+), 276 deletions(-)
>
Sasi,
when I told you that you can in certain situations ignore the 80 chars per line limit
(and in specific cases it is even expected) it was not a free pass for you to
create the extremely long lines like you did.
Also when I complained in V1 about the 
ERROR: DOS line endings
#80: FILE: drivers/scsi/megaraid/megaraid_sas.h:59:
+#define PCI_DEVICE_ID_LSI_MECTOR^I^I    0x00D4^M$
I was hoping you'd have removed these and didn't check any more - but they are still there
(Easy way how to avoid these errors is to use any linux editor, when you edit the patches.)
Some of those issues may be fixed when the patch is added to a git tree, so I'll
leave final decision on our maintainer and try to not comment any more on this kind of issues.

Cheers,
Tomas
