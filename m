From: John David Anglin <dave.anglin@bell.net>
Subject: Re: parisc late boot crash in 4.4-rc, scsi-related
Date: Wed, 6 Jul 2016 09:30:22 -0400
Message-ID: <ce0e6b44-c74a-c85e-51c0-3643b414e4d6@bell.net>
References: <alpine.LRH.2.20.1601082329270.23187@math.ut.ee>
 <9d1ae51e-69c3-c3f6-60aa-e5238dd18241@bell.net>
 <alpine.LRH.2.20.1606221451310.11869@math.ut.ee>
 <2098261.XbUFfohXuY@caliban.sf-tec.de>
 <alpine.LRH.2.20.1607060957560.8418@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1607060957560.8418@math.ut.ee>
Sender: linux-parisc-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-parisc@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-07-06 2:59 AM, Meelis Roos wrote:
>>> What distro are you using?
>>>
>>> My pariscs are gentoo and still only the old versions are available on
>>> hppa.
>> Several newer versions (4.9, 5.3) are in portage, maybe they just need to be
>> unmasked.
> 4.9.3 and 5.3.0 were too old.
Correct.  4.9.4 will include fix if it is released.
>
> However, at the end of June, 5.4.0 appeared masked. Unmasking kgcc64
> 5.4.0 and building it made my pariscs work again, with 4.7-rc6 running
> fine on all of them.
Great!  Thanks for report.

Dave

-- 
John David Anglin  dave.anglin@bell.net

