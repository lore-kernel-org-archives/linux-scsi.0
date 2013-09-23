From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/5] scsi: Fix assignment of 0/1 to bool variables
Date: Sun, 22 Sep 2013 17:29:29 -0700
Message-ID: <1379896169.3575.1.camel@joe-AO722>
References: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: JBottomley@parallels.com, naresh@chelsio.com, davem@davemloft.net, jj@chaosbits.net, arvindb@chelsio.com, hare@suse.de, michaelc@cs.wisc.edu, vijay.chauhan@netapp.com, bvanassche@acm.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2013-09-22 at 20:44 +0200, Peter Senna Tschudin wrote:
> Convert 0 to false and 1 to true when assigning values to bool
> variables. Inspired by commit 3db1cd5c05f35fb43eb134df6f321de4e63141f2.
[]
> @@
> bool b;
> @@
> -b = 1
> +b = true

You might also look for non-zero values other than 1
and convert those true too.
