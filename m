From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 4/6] mpt fusion: Creation of mptsas.h header file
Date: Tue, 14 Aug 2007 16:28:03 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709167F5@NAMAIL4.ad.lsil.com>
References: <20070814184934.GS16277@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50681 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbXHNW2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 18:28:06 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070814184934.GS16277@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, August 14, 2007 12:50 PM, Matthew Wilcox wrote:  
> On Tue, Aug 14, 2007 at 04:15:38PM +0530, Prakash, Sathya wrote:
> > The data structure definitions from mptsas.c are moved to a 
> new header file mptsas.h
> 
> Why?  Are they used outside mptsas.c in some future patch?
> 

Having rougly 10 data structures, and nearly 100 lines of code, Id
prefer it to have it in a seperate header so our sources files is not so
cluttered with a bunch of structs and defines..   In our internal
sources, we do need this broken out into a seperate header due to its
inclusion in our IOCTLS sources.      
