From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] add u64 number parser
Date: Fri, 22 Jul 2016 18:32:23 -0700
Message-ID: <5e325cbb-a140-8f26-7402-5dc1a2cd07ea@sandisk.com>
References: <5792b919.0C1gyf+dF4XKu6Zj%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5792b919.0C1gyf+dF4XKu6Zj%james.smart@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/22/16 17:23, James Smart wrote:
> +	buf = kmalloc(len + 1, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +	memcpy(buf, s->from, len);
> +	buf[len] = '\0';

Hello James,

Have you considered to combine the above kmalloc() and memcpy() calls 
into a single kasprintf(GFP_KERNEL, "%.*s", len, s->from) call?

Bart.
