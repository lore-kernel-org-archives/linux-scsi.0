From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Sun, 02 Mar 2003 16:08:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6272EA.5000709@splentec.com>
References: <20030228111924.A32018@beaverton.ibm.com> <3E627037.9060809@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E627037.9060809@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

I wrote:
[cut]
> 
> I also prefer the prefix ``_cmd_q'' since it describes

That's ``postfix'', but you knew that...

> that it is a _command queue_, and phonetically ``q''
> *is* ``queue'', thus there's no reason to spell it out
> in variable names.  But I don't have problems with
> a prefix of ``_q'', as well, which is what I've used

Same here.

> myself.

[cut]

-- 
Luben



