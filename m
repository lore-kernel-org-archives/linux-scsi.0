From: Alex Tomas <bzzz@tmi.comex.ru>
Subject: Re: -test4 detects scsi hdds in another order than -test2 does
Date: Fri, 29 Aug 2003 21:34:39 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3vfsgnz9s.fsf@bzzz.home.net>
References: <m33cfm19ar.fsf@bzzz.home.net> <3F4E4605.6040706@wmich.edu>
	<m3vfshrola.fsf@bzzz.home.net> <3F4F7129.1050506@wmich.edu>
	<m3vfsgpj8b.fsf@bzzz.home.net> <20030829091135.559a121f.akpm@osdl.org>
	<m3d6eopfvt.fsf_-_@bzzz.home.net>
	<20030829100356.512debe7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tmi.comex.ru ([217.10.33.92]:28566 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S261595AbTH2R3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 13:29:10 -0400
In-Reply-To: <20030829100356.512debe7.akpm@osdl.org> (Andrew Morton's
 message of "Fri, 29 Aug 2003 10:03:56 -0700")
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Alex Tomas <bzzz@tmi.comex.ru>, linux-scsi@vger.kernel.org

>>>>> Andrew Morton (AM) writes:

 AM> Alex Tomas <bzzz@tmi.comex.ru> wrote:
 >> 
 >> output for -test4:
 >> 
 >> ...
 >> 
 >> output for -test2:
 >> 

 AM> Make it easy for us please.  What is the difference between these two?  What
 AM> bug are we looking for?

with -test2 first found drive is IBM DNES, 2nd - QUANTUM.
with -test4 first found drive is QUANTUM, 2nd - IBM DNES


