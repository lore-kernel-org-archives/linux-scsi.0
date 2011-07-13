From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] RESEND ibmmca: trivial typo fixes
Date: Tue, 12 Jul 2011 21:46:24 -0700
Message-ID: <1310532384.1662.2.camel@Joe-Laptop>
References: <1310530933.4444.8.camel@offbook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1310530933.4444.8.camel@offbook>
Sender: linux-kernel-owner@vger.kernel.org
To: dave@gnu.org
Cc: trivial <trivial@kernel.org>, lkml <linux-kernel@vger.kernel.org>, Michael Lang <langa2@kph.uni-mainz.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-07-13 at 00:22 -0400, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> diff --git a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
[]
> @@ -487,7 +487,7 @@
>     1) Submitting the extra-array ldn_is_tape[] -> to the local ld[]
>        device-array. 
>     2) CD-ROM Audio-Play seems to work now.
> -   3) When using DDS-2 (120M) DAT-Tapes, mtst shows still density-code
> +   3) When using DDS-2 (120M) DAT-Tapes, must show still density-code

I think the original is correct.
mtst is a utility.
