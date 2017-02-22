From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] cciss: Fix coccinelle/checkpatch warnings.
Date: Wed, 22 Feb 2017 08:34:09 -0700
Message-ID: <e32ed294-f3f7-c877-2ad5-f5756c8e97f9@kernel.dk>
References: <1487743958-4208-1-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1487743958-4208-1-git-send-email-me@tobin.cc>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Tobin C. Harding" <me@tobin.cc>, Don Brace <don.brace@microsemi.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/21/2017 11:12 PM, Tobin C. Harding wrote:
> Re-send after spell checking. :(
> 
> Coccinelle warns about unnecessary cast on call to kmalloc(). Checkpatch
> emits various warnings when parsing file.
> 
> Clean up two checkpatch warnings. Remove trailing whitespace and
> clean up opening brace position. Remove unnecessary cast on kmalloc().
> 
> Tobin C. Harding (3):
>   cciss: Fix checkpatch TRAILING_WHITESPACE
>   cciss: Fix checkpatch OPEN_BRACE
>   cciss: Remove kmalloc cast

Applied, thanks.

-- 
Jens Axboe

