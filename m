From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: coding style question
Date: Wed, 25 Feb 2004 11:29:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040225112905.33bfdea8.rddunlap@osdl.org>
References: <20040225182523.GD25779@parcelfarce.linux.theplanet.co.uk>
	<Pine.LNX.4.44.0402251128430.6557-100000@dent.deepthot.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:64966 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261262AbUBYT3X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 14:29:23 -0500
In-Reply-To: <Pine.LNX.4.44.0402251128430.6557-100000@dent.deepthot.org>
List-Id: linux-scsi@vger.kernel.org
To: Jay Denebeim <denebeim@deepthot.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 25 Feb 2004 11:40:27 -0700 (MST) Jay Denebeim wrote:

| On Wed, 25 Feb 2004, Matthew Wilcox wrote:
| 
| > On Wed, Feb 25, 2004 at 06:16:48PM +0000, Jay Denebeim wrote:
| (I mentioned typedefs being removed)
| > > what was the reasoning for this?
| > 
| > We hate typedefs.
| 
| Well, that's certainly convincing.  Funny that, I don't recall hating
| typedefs, in fact I distinctly recall liking them and being happy when
| they were added to Lattice's Amiga compiler back in the stone age.  Is
| there some particular reason 'we' hate them?

For anything other than very basic types, they hide/obfuscate
data structures.  If it's a struct, we had rather see a struct
used there.

--
~Randy
