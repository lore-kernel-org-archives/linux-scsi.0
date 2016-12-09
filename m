From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V4 05/11] megaraid_sas: SAS3.5 Generic Megaraid
 Controllers Fast Path for RAID 1/10 Writes
Date: Fri, 9 Dec 2016 11:54:43 +0100
Message-ID: <fa806409-b63d-d365-27a6-36838991434c@redhat.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
 <1481065220-18431-6-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481065220-18431-6-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 7.12.2016 00:00, Sasikumar Chandrasekaran wrote:
> To improve RAID 1/10 Write performance, OS drivers need to issue the required Write
> IOs as Fast Path IOs (after the appropriate checks allowing Fast Path to be used)
> to the appropriate physical drives (translated from the OS logical IO) and wait for
> all Write IOs to complete.  If any of the Write IOs fail or time out, the IO will be
> re issued to FW as an LD IO so FW can perform the error handling.
>
> This patch is depending on patch 4
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
