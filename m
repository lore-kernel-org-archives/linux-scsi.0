From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API &
 Library)
Date: Sat, 21 Jan 2012 08:57:05 -0600
Message-ID: <1327157825.2748.5.camel@dabdike.int.hansenpartnership.com>
References: <4F19A981.4080502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57521 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab2AUO5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jan 2012 09:57:08 -0500
In-Reply-To: <4F19A981.4080502@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tasleson@redhat.com
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Fri, 2012-01-20 at 11:50 -0600, Tony Asleson wrote:
> I would like to give a brief background on the storage management API
> and library that I have been working on** and discuss the design and
> implementation challenges that I have encountered thus far.
> 
> Most notable is the same topic Shyam Iyer brought up about proprietary
> plug-in support (http://marc.info/?l=linux-scsi&m=132454179114038&w=2).
> This very feature has influenced libStorageMgmt heavily and has raised a
> number of discussions on design and licensing.
> 
> Discussion topics
> * Scope (What a storage library should/should not do)
> * Role (library position in management stack)
> * Features (specific: must have to would be nice)
> * Usage scenarios which highlight needed features
> * Licensing (most appropriate open source license)
> * Proprietary plug-in support
> 
> 
> ** http://sourceforge.net/apps/trac/libstoragemgmt

Its a bit thin at 20 commits over 4 months.

It's also a bit insular ... the first thing you usually ask in open
source is what can I steal^Wborrow from other projects and how do I
recruit others to do the work for me.  Once you can actually answer
that, the list you have above mostly takes care of itself.

The first question is probably: is there anything we can liberate from
the Oracle storage API fisasco to help with this.  The second might be
what would it take to get vendors interested in doing the array plugin
glue.

James


