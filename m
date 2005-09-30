From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into the kernel
Date: Fri, 30 Sep 2005 14:22:34 -0600
Message-ID: <20050930202234.GA2571@parisc-linux.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01A9FA11@otce2k03.adaptec.com> <1128105594.10079.109.camel@bluto.andrew> <433D9035.6000504@adaptec.com> <1128111290.10079.147.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030388AbVI3UWq@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1128111290.10079.147.camel@bluto.andrew>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 30, 2005 at 02:14:50PM -0600, Andrew Patterson wrote:
> > > Note that a sysfs implementation has problems.  Binary attributes are
> > > discouraged/not-allowed.
> > 
> > I've never heard that.  Is this similar to the argument
> > "The sysfs tree would be too deep?"
> 
> >From Documentation/filesystes/sysfs.txt
> 
> "Attributes should be ASCII text files, preferably with only one value
> per file. It is noted that it may not be efficient to contain only
> value per file, so it is socially acceptable to express an array of
> values of the same type.
> 
> Mixing types, expressing multiple lines of data, and doing fancy
> formatting of data is heavily frowned upon. Doing these things may get
> you publically humiliated and your code rewritten without notice."
> 
> My understanding is that sysfs is meant to be human-readable.  I do not
> know if this is a hard and fast rule or just a convention.  Configfs is
> probably a better fit at least for writeable attributes, but may not be
> cooked yet.

There's precedent for binary data in sysfs -- pci config space is one.
