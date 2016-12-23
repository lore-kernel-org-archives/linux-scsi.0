From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 06/11] megaraid_sas: Dynamic Raid Map Changes for
 SAS3.5 Generic Megaraid Controllers
Date: Fri, 23 Dec 2016 16:13:00 +0100
Message-ID: <84a65c9a-c131-699d-946a-baee05a4087c@redhat.com>
References: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
 <1482455994-8047-7-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482455994-8047-7-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 23.12.2016 02:19, Sasikumar Chandrasekaran wrote:
> SAS3.5 Generic Megaraid Controllers FW will support new dynamic RaidMap to have different
> sizes for different number of supported VDs.
>
> This patch is depending on patch 5
>
> 80 chars per line limit is taken care around VD_EXT_DEBUG macro.
> NULL pointer check for desc_table has been removed.
> Few code indentation issues fixed.
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
