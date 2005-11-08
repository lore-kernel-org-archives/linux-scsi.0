From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: oops with USB Storage on 2.6.14
Date: Tue, 8 Nov 2005 13:33:06 -0800
Message-ID: <20051108213306.GA25219@us.ibm.com>
References: <C2EEB4E538D3DC48BF57F391F422779321ADC0@srmanning.eng.emc.com> <1131484123.3270.36.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030371AbVKHVdT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1131484123.3270.36.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "goggin, edward" <egoggin@emc.com>, 'Rolf Eike Beer' <eike-kernel@sf-tec.de>, 'Andrew Morton' <akpm@osdl.org>, Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 08, 2005 at 04:08:43PM -0500, James Bottomley wrote:
> On Tue, 2005-11-08 at 15:02 -0500, goggin, edward wrote:
> > Thanks!  Here's a better one.
> 
> It's line wrapped, but I fixed that up.

What code path triggered this?

I mean we get a ref to the sdev in the upper level driver opens, scan, and
sd flush. So where are we not getting a ref? 

Shouldn't the get be done at a higher level?

-- Patrick Mansfield
