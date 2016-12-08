From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V4 04/11] megaraid_sas: SAS3.5 Generic Megaraid
 Controllers Stream Detection and IO Coalescing
Date: Thu, 8 Dec 2016 17:00:38 +0100
Message-ID: <e3057d20-0723-6e48-2404-d30ffabecca2@redhat.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
 <1481065220-18431-5-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481065220-18431-5-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 7.12.2016 00:00, Sasikumar Chandrasekaran wrote:
> Detect sequential IO streams and pass those IOs directly to FW.
>
> This patch is depending on patch 3
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

Indentation in megasas_stream_detect is wrong on several places,
but ok for now.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
