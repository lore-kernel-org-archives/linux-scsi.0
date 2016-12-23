From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 02/11] megaraid_sas: 128 MSIX Support
Date: Fri, 23 Dec 2016 16:09:24 +0100
Message-ID: <de2ecdc1-8a88-9dc7-57a9-a399412566bc@redhat.com>
References: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
 <1482455994-8047-3-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482455994-8047-3-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 23.12.2016 02:19, Sasikumar Chandrasekaran wrote:
> SAS3.5 Generic Megaraid based Controllers will have the support for 128 MSI-X vectors,
> resulting in the need to support 128 reply queues
>
> This patch is depending on patch 1 and same as V5
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
