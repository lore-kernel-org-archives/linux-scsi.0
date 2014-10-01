From: Jan Kara <jack@suse.cz>
Subject: Re: ext4: 3.17? problems
Date: Wed, 1 Oct 2014 10:50:18 +0200
Message-ID: <20141001085018.GB17405@quack.suse.cz>
References: <20140929114408.GC2738@quack.suse.cz>
 <87iok6ojis.fsf@openvz.org>
 <20140928124658.GB6694@thunk.org>
 <20140930210108.GB14283@amd>
 <20140930231801.GB729@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140930231801.GB729@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Ts'o <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz, linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, Dmitry Monakhov <dmonakhov@openvz.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue 30-09-14 20:18:01, Henrique de Moraes Holschuh wrote:
> On Tue, 30 Sep 2014, Pavel Machek wrote:
> > > > So I had to hard power-down the machine. That should be perfectly
> > > > safe, as ext4 has a journal, and this is plain SATA disk, right?
> > >   Yes, it should be safe.
> > 
> > Good.
> 
> ...
> 
> > Is there some phase during shutdown where journalling no longer
> > protects fs integrity?
> 
> Hmm... what kind of backing device?  Because I have Crucial/Micron M500 SSDs
> here that _always_ complain (in a SMART counter/attribute) that they have
> been subject to a sudden poweroff *when subject to a normal system
> shutdown*.
> 
> This is scaring me a great deal.  Are we doing something different for SSDs
> in the scsi-sd or libata shutdown paths?
  Nothing I'm aware of but this is more a question for SCSI guys (added to
CC).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
