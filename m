From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Fri, 25 Oct 2002 00:36:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025003652.A5864@infradead.org>
References: <dledford@redhat.com> <200210231416.g9NEGoI01976@localhost.localdomain> <20021023171335.B17312@lst.de> <20021024232026.GF17575@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021024232026.GF17575@linnie.riede.org>; from wrlk@riede.org on Thu, Oct 24, 2002 at 07:20:26PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 24, 2002 at 07:20:26PM -0400, Willem Riede wrote:
> > Well, I'm working on removing ->init.  With the patch posted yersterday
> > only sg.c and osst.c are left implementing it.
> > 
> Ermm, osst (which I maintain) works the same as st in this respect.
> I didn't notice any changes to st.c in that patch. What am I missing?

st in 2.5 doesn't have ->init and ->finish anymore.  Time for a resync? :)

