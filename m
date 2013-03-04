From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [PATCH] st: Take additional queue ref in st_probe
Date: Mon, 4 Mar 2013 23:42:28 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB34358480@G9W0766.americas.hpqcorp.net>
References: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:44832 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3CDXnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Mar 2013 18:43:45 -0500
In-Reply-To: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Ewan Milne <emilne@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, =?iso-8859-1?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>

With the things I've been doing in st it was easier to reboot than unload/load the st driver since it would likely cause an oops. I applied the patch and have tested it and the st module unloads/reloads with no problems now. 
