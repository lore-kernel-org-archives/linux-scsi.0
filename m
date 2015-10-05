From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Mon, 5 Oct 2015 07:11:51 -0700
Message-ID: <56128527.1000703@sandisk.com>
References: <20151004080217.GA22816@infradead.org>
 <1444037200-14684-1-git-send-email-linux@rasmusvillemoes.dk>
 <1444037200-14684-3-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444037200-14684-3-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/05/15 02:26, Rasmus Villemoes wrote:
>   struct error_info {
>   	unsigned short code12;	/* 0x0302 looks better than 0x03,0x02 */
> -	const char * text;
> +	unsigned short size;
>   };

Had you considered to use the type uint16_t instead of unsigned short ?

Bart.
