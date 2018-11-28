From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Nov 27 (scsi/aha1542)
Date: Tue, 27 Nov 2018 20:14:58 -0800
Message-ID: <ef9090cf-e86a-7fd0-dfa9-6810eaaf7e65@infradead.org>
References: <20181127152539.55426063@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181127152539.55426063@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/26/18 8:25 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20181126:
> 

on i386:

ERROR: "__udivdi3" [drivers/scsi/aha1542.ko] undefined!

somewhere in aha1542_interrupt() according to objdump.


-- 
~Randy
