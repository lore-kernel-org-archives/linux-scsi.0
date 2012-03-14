From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [Lsf-pc] Bcache
Date: Wed, 14 Mar 2012 15:09:12 -0700
Message-ID: <CABE8wwvtH818aP18r0XgGgiCCFLOKJXCzHdysQeAGC93SETPBw@mail.gmail.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
	<20120314155339.GC30235@redhat.com>
	<CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
	<20120314220150.GA15464@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:37627 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965247Ab2CNWJO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 18:09:14 -0400
Received: by iage36 with SMTP id e36so3227183iag.25
        for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 15:09:13 -0700 (PDT)
In-Reply-To: <20120314220150.GA15464@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, nauman@google.com, lsf-pc@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

On Wed, Mar 14, 2012 at 3:01 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> I'm very early in the design but hope to have an initial functional
> version of the code together in time for LSF -- ~2 weeks may be too
> ambitious but it's my goal (could be more doable if I confine the
> initial code to writethrough with LRU).

I'm hoping caching ends up being as successful as the raid456
unification where we can have a dm or md interface in front of some
common infrastructure.  The inertia for md is to keep it close to all
the recent software raid advancements, the inertia for dm is also
clear, the inertia for something brand new... not very clear.

--
Dan
