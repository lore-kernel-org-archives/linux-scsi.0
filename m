From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: isp1020 memory trample in 2.5.66
Date: Thu, 3 Apr 2003 00:55:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030403085545.GB19627@holomorphy.com>
References: <Pine.LNX.4.50.0304020101460.8773-100000@montezuma.mastecende.com> <20030402080226.A25288@beaverton.ibm.com> <Pine.LNX.4.50.0304030317230.30262-100000@montezuma.mastecende.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.50.0304030317230.30262-100000@montezuma.mastecende.com>
List-Id: linux-scsi@vger.kernel.org
To: Zwane Mwaikambo <zwane@linuxpower.ca>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 2 Apr 2003, Patrick Mansfield wrote:
>> Martin hit it when the queue depth was not properly checked.
>> wli has hit it with parallel mkfs (or something).

On Thu, Apr 03, 2003 at 03:27:38AM -0500, Zwane Mwaikambo wrote:
> Ok this thing sounds _very_ fragile ;)

Debugging ode this obfuscated and crappy is as hopeless as trying to
debug the nvidia binary-only oops-o-rama.

What are the odds of just throwing away the isp1020 and replacing it
with anything else? It won't fix it, but it can't be fixed due to
utter lack of information about the things and/or lack of maintainers
with information hidden by NDA's anyway.


-- wli
