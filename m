From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] ide-scsi: use print_hex_dump from <linux/kernel.h>
Date: Tue, 27 Nov 2007 11:34:16 -0800
Message-ID: <1196192056.31590.54.camel@localhost>
References: <1196061373-6394-1-git-send-email-crquan@gmail.com>
	 <20071127013119.d12b7791.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20071127013119.d12b7791.akpm@linux-foundation.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Cheng <crquan@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2007-11-27 at 01:31 -0800, Andrew Morton wrote:
> Either way, perhaps a simple little front-end to print_hex_dump() is called
> for.

Perhaps an even simpler generic version of what's
now used in crypto/tcrypt.c:

void print_cont_hex_dump_bytes(const void *buf, size_t len)
{
	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE,
		       16, 1, buf, len, false);
}

or just use print_hex_dump_bytes.


