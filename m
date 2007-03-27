From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.21-rc5
Date: Tue, 27 Mar 2007 09:46:23 -0700
Message-ID: <20070327094623.417014db.randy.dunlap@oracle.com>
References: <1175012677.3737.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933217AbXC0Qqo@vger.kernel.org>
In-Reply-To: <1175012677.3737.18.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 27 Mar 2007 11:24:37 -0500 James Bottomley wrote:

> This is a fairly basic rollup of 3 basic double free or oops based bug
> fixes.


It's disappointing that kernel-doc fixes are not being merged.
Yes, they are not code bug fixes, but they are doc bug fixes,
and some of us do work to try to keep them in good shape.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
