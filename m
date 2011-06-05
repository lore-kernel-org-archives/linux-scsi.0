From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.39 kernel panic w/screenshots & kernel cfg link provided
Date: Sun, 5 Jun 2011 16:04:52 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1106051601230.3462@p34.internal.lan>
References: <alpine.DEB.2.02.1105280755050.4345@p34.internal.lan> <4DE4FBB0.9080708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DE4FBB0.9080708@fnarfbargle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Tue, 31 May 2011, Brad Campbell wrote:

> On 28/05/11 20:01, Justin Piszcz wrote:
>> Hello,

Hi,

This was happening on a regular basis, since then I have performed the
following: (sdc,sdd,sde were recently added)

# hal-disable-polling --device /dev/sr0
Polling is already disabled on the given drive.
# hal-disable-polling --device /dev/sdd
Polling for drive /dev/sdd have been disabled. The fdi file written was
# hal-disable-polling --device /dev/sde
Polling for drive /dev/sde have been disabled. The fdi file written was
# hal-disable-polling --device /dev/sdc
Polling for drive /dev/sdc have been disabled. The fdi file written was

# ps auxww|grep udisks
root      4125  0.0  0.0 127464  5844 ?        Sl   07:54   0:00 /usr/lib/udisks/udisks-daemon
root      4126  0.0  0.0  45088  1100 ?        S    07:54   0:00 udisks-daemon: polling /dev/sr0 /dev/sdd /dev/sde /dev/sdc
root     13335  0.0  0.0   8648   844 pts/8    S+   08:23   0:00 grep udisks
# dpkg -S /usr/lib/udisks/udisks-daemon
udisks: /usr/lib/udisks/udisks-daemon
# apt-get remove udisks

# uname -a
Linux box 2.6.39 #11 SMP Tue May 31 15:51:52 EDT 2011 x86_64 GNU/Linux

So far, my system has not crashed in 4 days after doing this, I am also 
using the 'threadirqs' boot option, if it crashes again I'll provide an update
but so far it has been stable..

Justin.
