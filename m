From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Thu, 24 Oct 2002 20:02:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025000248.GH17575@linnie.riede.org>
References: <dledford@redhat.com> <200210231416.g9NEGoI01976@localhost.localdomain> <20021023171335.B17312@lst.de> <20021024232026.GF17575@linnie.riede.org> <20021025003652.A5864@infradead.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021025003652.A5864@infradead.org>; from hch@infradead.org on Thu, Oct 24, 2002 at 19:36:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On 2002.10.24 19:36 Christoph Hellwig wrote:
> On Thu, Oct 24, 2002 at 07:20:26PM -0400, Willem Riede wrote:
> > > Well, I'm working on removing ->init.  With the patch posted yersterday
> > > only sg.c and osst.c are left implementing it.
> > >
> > Ermm, osst (which I maintain) works the same as st in this respect.
> > I didn't notice any changes to st.c in that patch. What am I missing?
> 
> st in 2.5 doesn't have ->init and ->finish anymore.  Time for a resync? :)
> 
Obviously. I'll do that. I have to admit I've kind of ignored 2.5.x to
let it stabilize before spending effort on keeping osst up to date,
but it looks like it's time to make up for lost time...

Thanks, Willem Riede.
