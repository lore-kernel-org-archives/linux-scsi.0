From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: target_core_transport.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
Date: Fri, 22 Aug 2014 13:47:52 -0700
Message-ID: <1408740472.24496.5.camel@haakon3.risingtidesystems.com>
References: <1407102622-8806-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407102622-8806-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Rickard,

On Sun, 2014-08-03 at 23:50 +0200, Rickard Strandqvist wrote:
> Ensures that the string is null-terminate in connection with the
> use of strncpy. Optimized code by replacing unnecessary sprintf
> with strlcat and more, and simultaneously guarantees that the
> string does not get bigger than sizeof.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---

Apologies for missing this patch earlier.

Applied to target-pending.

Thanks!

--nab
