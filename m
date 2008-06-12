From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [RFC] Move FC definitions from zfcp to global header
Date: Thu, 12 Jun 2008 08:19:22 -0700
Message-ID: <10A7D0016239E24092DEF05CCC582E4303DF5C54@fmsmsx411.amr.corp.intel.com>
References: <20080612130245.GA13761@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYFLPTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 11:19:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080612130245.GA13761@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org



>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Christof Schmitt
>Sent: Thursday, June 12, 2008 6:03 AM
>To: linux-scsi@vger.kernel.org
>Subject: [RFC] Move FC definitions from zfcp to global header
>
>This was suggested a while ago, now i finally put together a patch
>that moves the Fibre Channel protocol definitions from zfcp to a new
>global header file. With the global header, the definitions can be
>shared across all FC drives.
>
>The new file contains only the definitions used by zfcp. My idea is
>that others add definitions for other parts of the protocols as
>needed.
>
>Would this approach be ok, or should i take a different approach?
>
This is the approach that the Open-FCoE re-architecture tree has taken,
at least in regards to having common FC definitions. The only difference
being that our tree has a bunch of headers in include/scsi/fc/. Ours are
split out into about 8 files; however, we shouldn't be using all of
them, so consolidating the necessary/used definitions into one file
should work well for us.
