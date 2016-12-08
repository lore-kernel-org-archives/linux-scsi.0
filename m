From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V4 03/11] megaraid_sas: EEDP Escape Mode Support for
 SAS3.5 Generic Megaraid Controllers
Date: Thu, 8 Dec 2016 16:35:34 +0100
Message-ID: <ee499d59-c9e6-a7c0-57c6-0d5e7def4b7a@redhat.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
 <1481065220-18431-4-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481065220-18431-4-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 7.12.2016 00:00, Sasikumar Chandrasekaran wrote:
> An UNMAP command on a PI formatted device will leave the Logical Block Application
> Tag and Logical Block Reference Tag as all F's (for those LBAs that are unmapped).
> To avoid IO errors if those LBAs are subsequently read before they are written with
> valid tag fields, the MPI SCSI IO requests need to set the EEDPFlags element EEDP
> Escape Mode field, Bits [7:6] appropriately.  A value of 2 should be set to disable
> all PI checks if the Logical Block Application Tag is 0xFFFF for PI types 1 and 2.
> A value of 3 should be set to disable all PI checks if the Logical Block Application
> Tag is 0xFFFF and the Logical Block Reference Tag is 0xFFFFFFFF for PI type 3.
>
> This patch is depending on patch 2
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
