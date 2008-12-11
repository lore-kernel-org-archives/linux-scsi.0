From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Thu, 11 Dec 2008 20:24:42 +0100
Message-ID: <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:57878 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbYLKTYo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2008 14:24:44 -0500
In-Reply-To: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@hansenpartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

On Thu, Dec 11, 2008 at 4:14 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Things are moving quickly for Target_Core_Mod/ConfigFS and LIO-Target
> v3.0 development, and I invite folks to have a look at the code.  To
> dive into the rest of the v3.0 code via git-web, check out:
>
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/lio-core

I didn't have a look at the LIO code, but I ran it through checkpatch.
The result summary is as follows:

$ cat lio-checkpatch-output.txt | grep -E '^WARNING|^ERROR' | sort |
uniq -c | sort -rn
   2419 ERROR: return is not a function, parentheses are not required
   2303 WARNING: line over 80 characters
   1950 ERROR: trailing whitespace
   1801 WARNING: space prohibited between function name and open parenthesis '('
    758 ERROR: code indent should use tabs where possible
    698 ERROR: do not use assignment in if condition
    407 WARNING: labels should not be indented
    386 ERROR: spaces required around that ':' (ctx:VxW)
    312 ERROR: do not use C99 // comments
    309 WARNING: externs should be avoided in .c files
    205 WARNING: printk() should include KERN_ facility level
    103 WARNING: do not add new typedefs
     62 ERROR: space required before that '*' (ctx:OxV)
     58 WARNING: consider using a completion
     55 WARNING: unnecessary cast may hide bugs, see
http://c-faq.com/malloc/mallocnocast.html
     48 WARNING: consider using strict_strtoul in preference to
simple_strtoul
     41 ERROR: spaces required around that ':' (ctx:VxV)
     38 WARNING: EXPORT_SYMBOL(foo); should immediately follow its
function/variable
     32 ERROR: Macros with multiple statements should be enclosed in a
do - while loop
     28 ERROR: else should follow close brace '}'
     27 WARNING: kfree(NULL) is safe this check is probably not
required
     23 WARNING: braces {} are not necessary for any arm of this
statement
     18 ERROR: open brace '{' following struct go on the same line
     16 ERROR: spaces required around that '?' (ctx:VxW)
     15 ERROR: space required after that ',' (ctx:VxV)
     11 ERROR: switch and case should be at the same indent
      8 WARNING: mutexes are preferred for single holder semaphores
      8 WARNING: __func__ should be used instead of gcc specific
__FUNCTION__
      8 WARNING: braces {} are not necessary for single statement
blocks
      6 ERROR: spaces required around that '?' (ctx:VxE)
      6 ERROR: space required before the open parenthesis '('
      5 WARNING: suspect code indent for conditional statements (15,
23)
      5 ERROR: Macros with complex values should be enclosed in
parenthesis
      5 ERROR: Don't use kernel_thread(): see
Documentation/feature-removal-schedule.txt
      5 ERROR: do not initialise externals to 0 or NULL
      4 WARNING: suspect code indent for conditional statements (2, 4)
      4 ERROR: spaces required around that ':' (ctx:VxE)
      4 ERROR: space required after that ';' (ctx:VxV)
      3 WARNING: suspect code indent for conditional statements (8,
17)
      3 WARNING: suspect code indent for conditional statements (7,
15)
      3 WARNING: suspect code indent for conditional statements (24,
33)
      3 WARNING: suspect code indent for conditional statements (0, 0)
      3 ERROR: trailing statements should be on next line
      3 ERROR: that open brace { should be on the previous line
      3 ERROR: spaces required around that '>=' (ctx:WxV)
      3 ERROR: spaces required around that '&&' (ctx:VxV)
      3 ERROR: spaces required around that '=' (ctx:VxV)
      3 ERROR: do not initialise statics to 0 or NULL
      2 WARNING: Use #include <linux/types.h> instead of <asm/types.h>
      2 WARNING: suspect code indent for conditional statements (8, 0)
      2 WARNING: suspect code indent for conditional statements (16,
25)
      2 WARNING: consider using strict_strtol in preference to
simple_strtol
      2 ERROR: need consistent spacing around '*' (ctx:WxV)
      1 WARNING: Use #include <linux/byteorder.h> instead of
<asm/byteorder.h>
      1 WARNING: trailing semicolon indicates no statements, indent
implies otherwise
      1 WARNING: suspect code indent for conditional statements (9,
13)
      1 WARNING: suspect code indent for conditional statements (8,
15)
      1 WARNING: suspect code indent for conditional statements (6,
15)
      1 WARNING: suspect code indent for conditional statements (4, 6)
      1 WARNING: suspect code indent for conditional statements (33,
41)
      1 WARNING: suspect code indent for conditional statements (32,
41)
      1 WARNING: suspect code indent for conditional statements (16,
23)
      1 WARNING: suspect code indent for conditional statements (16,
16)
      1 WARNING: suspect code indent for conditional statements (0, 4)
      1 WARNING: consider using strict_strtoull in preference to
simple_strtoull
      1 ERROR: spaces required around that ':' (ctx:WxV)
      1 ERROR: spaces required around that '=' (ctx:WxV)
      1 ERROR: spaces required around that '<' (ctx:VxV)
      1 ERROR: spaces required around that '==' (ctx:VxE)
      1 ERROR: spaces prohibited around that '->' (ctx:VxW)
      1 ERROR: space required before that '!' (ctx:VxE)
      1 ERROR: space prohibited after that '!' (ctx:BxW)
      1 ERROR: space prohibited after that '-' (ctx:BxW)
      1 ERROR: open brace '{' following union go on the same line
      1 ERROR: Missing Signed-off-by: line(s)
      1 ERROR: "(foo*)" should be "(foo *)"
      1 ERROR: "foo * bar" should be "foo *bar"

Bart.
