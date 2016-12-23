From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 08/11] megaraid_sas: Enable or Disable Fast path based
 on the PCI Threshold Bandwidth
Date: Fri, 23 Dec 2016 16:13:35 +0100
Message-ID: <fd9eb25d-eef4-8d1a-8484-9fa0d4172f74@redhat.com>
References: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
 <1482455994-8047-9-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482455994-8047-9-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 23.12.2016 02:19, Sasikumar Chandrasekaran wrote:
> Large SEQ IO workload should sent as non fast path commands
>
> This patch is depending on patch 7
>
> 80 chars per line limit is taken care around VD_EXT_DEBUG macro.
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
