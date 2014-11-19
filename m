From: Greg KH <greg@kroah.com>
Subject: Re: Backport of a fix for a race condition in HPSA driver (3rd time
 is the charm)
Date: Tue, 18 Nov 2014 17:47:01 -0800
Message-ID: <20141119014701.GI22731@kroah.com>
References: <CANcb+4vTzLBGkkvrBo-dsCERFvX-J=D-4Sgx6Vz_-e1jJpokYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANcb+4vTzLBGkkvrBo-dsCERFvX-J=D-4Sgx6Vz_-e1jJpokYQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Masoud Sharbiani <msharbiani@twopensource.com>
Cc: stable@vger.kernel.org, thenzl@redhat.com, scameron@beardog.cce.hp.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 14, 2014 at 11:26:08AM -0800, Masoud Sharbiani wrote:
> Dear stable maintainers,
> Can you please backport commitid
> 2cc5bfaf854463d9d1aa52091f60110fbf102a9 ([SCSI] hpsa: fix a race in
> cmd_free/scsi_done) to 3.10 stable (and earlier, if applicable)? It
> seems to fix an issue that we have run into a couple of times.
> 
> Many thanks,
> Masoud Sharbiani <msharbiani@twitter.com> <msharbiani@twopensource.com>

Applied, thanks.

greg k-h
