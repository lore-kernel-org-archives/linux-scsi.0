From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] async scsi resume for 3.15
Date: Fri, 11 Apr 2014 17:50:34 -0700
Message-ID: <CA+55aFysUsOsK-dUYbWhMGcG2c9_nFjoJgBkb72hevh48TCABg@mail.gmail.com>
References: <1397179458.4303.23.camel@dwillia2-mobl2.amr.corp.intel.com>
	<1397240450.2626.37.camel@dabdike.int.hansenpartnership.com>
	<CA+55aFxMhHbcXiG+=dQAMz4W1UarvnNkajBQJVhw8DH1ENwhig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxMhHbcXiG+=dQAMz4W1UarvnNkajBQJVhw8DH1ENwhig@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, "Brown, Len" <len.brown@intel.com>, Phillip Susi <psusi@ubuntu.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 11, 2014 at 5:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This has been the biggest (by far) merge window so far, afaik.
> Might as well take this too.

Actually, I take that "by far" back. In fact it's not even the biggest
one (yet). It looks like 3.10-rc1 was worse in number of commits, and
v3.7-rc1 was bigger in number of lines and files.

That may still change by the time I tag rc1, but it looks like while
the current merge window is big, it's not actually going to break any
records.

Regardless, I pulled the async scsi resume patch.

          Linus
