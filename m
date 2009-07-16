From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 16:36:14 +0200
Message-ID: <4A5F3ADE.2040109@s5r6.in-berlin.de>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <4A5F3975.70503@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A5F3975.70503@s5r6.in-berlin.de>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> The comment should specify what the actual effects of the flag are.
[...]
> (Is used by power management infrastructure to decide over runtime PM
> policy?  I.e. don't enter power states which would prevent the port from
> detecting/ reporting hotplug events?)

Perhaps the flag should be called differently (keep_ports_powered or
whatever) --- unless you have additional future uses of the flag in mind
which justify the more generic name.
-- 
Stefan Richter
-=====-==--= -=== =----
http://arcgraph.de/sr/
