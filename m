From: Doug Ledford <dledford@redhat.com>
Subject: Re: scsi_scan.c question
Date: Wed, 16 Oct 2002 20:18:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021017001826.GI8159@redhat.com>
References: <dledford@redhat.com> <20021016213518.GE8159@redhat.com> <200210162141.g9GLfpE04327@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210162141.g9GLfpE04327@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 16, 2002 at 02:41:51PM -0700, James Bottomley wrote:
> dledford@redhat.com said:
> > Is anyone still working on this code or have the changes other people
> > wanted to make all been integrated? 
> 
> I have some changes to throw most of it away and re-implement it in user space 
> using hotplug instead.

(Not a bad plan, I rather like that idea myself)

>  I think this type of thing is a little radical for the 
> eve of 2.6, so feel free to alter scsi_scan.c in any way you want.

OK, then I'm working on it as soon as my 2.5 test box works right again 
(ServerWorks IDE seems broke on my box and I don't have the time to fix it 
when I've got this other stuff waiting).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
