From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Fri, 14 Feb 2003 13:50:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030214135046.A21504@redhat.com>
References: <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com> <20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com> <20030213192440.A6660@redhat.com> <20030214165827.GA1165@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030214165827.GA1165@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, Feb 14, 2003 at 08:58:27AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Feb 14, 2003 at 08:58:27AM -0800, Mike Anderson wrote:
> The need is there for per target data, but if we talk about future
> directions it would appear a cleaner interface would be to have luns as
> children of the targets (? ports ?) vs having a list of luns and post linking
> relationships.

Yes it would be cleaner.  I haven't had the time to work on scsi lately 
(job responsibility issues) and so I'm not one to go telling people what 
to do.  I suggested an easy alternative, while this requires, I think, 
quite a bit more work to restructure things.  If I had the time to do it 
myself this is the direction I would be looking in.  It has other side 
benefits as well, like you can simplify the scsi scanning code a little 
bit because the lun0 scsi level would always be device->target->scsi_level 
and I'm sure other minor optimizations can be made.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
