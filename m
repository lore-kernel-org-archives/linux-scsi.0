From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V4 09/11] megaraid_sas: ldio_outstanding variable is not
 decremented in completion path
Date: Fri, 9 Dec 2016 15:01:12 +0100
Message-ID: <4805b3fe-f7cf-e0bc-edb6-6ead0e28c0c4@redhat.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
 <1481065220-18431-10-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481065220-18431-10-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 7.12.2016 00:00, Sasikumar Chandrasekaran wrote:
> ldio outstanding variable needs to be decremented in io completion path for
> iMR dual queue depth
>
> This patch is depending on patch 8
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
