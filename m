From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 19:51:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16udIR-0pQ920C@fmrl04.sul.t-online.com>
References: <20020408091844.L7333@austin.ibm.com> <20020408160445.A25213@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-Reply-To: <20020408160445.A25213@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Monday 08 April 2002 17:04, Christoph Hellwig wrote:
> On Mon, Apr 08, 2002 at 09:18:44AM -0600, sullivan wrote:
> > I would welcome any thoughts, comments, or suggestions.
>
> What is the rationale for doing this?  I think we should rather get people
> to actually use the UUID= option to mount..

UUID cannot solve the problem. It identifies filesystems.
There's a need to identify devices. Not everything
is a hard drive with a filesystem on it.

	Regards
		Oliver
