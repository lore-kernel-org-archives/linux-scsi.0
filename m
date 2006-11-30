From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Infinite retries reading the partition table
Date: Wed, 29 Nov 2006 17:22:48 -0800 (PST)
Message-ID: <617182.73467.qm@web31807.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S967791AbWK3BWu@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Suppose reading sector 0 always reports an error,
sense key HARDWARE ERROR.

What I'm observing is that the request to read sector 0,
reading partition information, is retried forever, ad infinitum.

Does anyone have a patch to resolve this? (2.6.19-rc6)

Thanks,
    Luben
