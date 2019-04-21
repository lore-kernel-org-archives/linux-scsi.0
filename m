From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] fdomain: Resurrect driver
Date: Sat, 20 Apr 2019 23:35:13 -0700
Message-ID: <20190421063513.GA2288@infradead.org>
References: <20190420201126.827-1-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190420201126.827-1-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As mentioned before:  please drop the unused ISA and PCIMCIA code.
We don't need to (re-)add untested code.
