From: Uns Lider <unslider@miranda.org>
Subject: sym53c8xx_2 ppr problems
Date: Tue, 11 Jan 2005 12:37:53 -0500 (EST)
Message-ID: <Pine.LNX.4.58.0501111228530.30502@miranda.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.org ([209.58.150.153]:46210 "HELO miranda.org")
	by vger.kernel.org with SMTP id S261214AbVAKRhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 12:37:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FWIW... I just upgraded from 2.4.9 to 2.6.10. 2.6.10 kept printing phase
change 6-7 messages. I patched to sym53c8xx_2 2.1.18n, but that didn't
help. So I modified scsi_scan.c and sym_hipd.c sym_prepare_nego to never
try PPR. That made the messages go away.

00:0a.0 SCSI storage controller: Symbios Logic Inc. (formerly NCR) 53c1010 Ultra3 SCSI Adapter (rev 01)
(on a tekram dc390u3w)
  Vendor: SEAGATE   Model: SX150176LC        Rev: BA08
  Type:   Direct-Access                      ANSI SCSI revision: 02
(=st150176lc, fast-40, lvd)

It sounds like PPR only does anything for fast-80 and above drives so I
guess I'm OK now.

-- uns
