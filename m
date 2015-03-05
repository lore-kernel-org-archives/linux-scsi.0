From: Andy Grover <agrover@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Thu, 05 Mar 2015 10:38:40 -0800
Message-ID: <54F8A2B0.70202@redhat.com>
References: <54B7E70C.8020304@sandisk.com> <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com> <54E7112F.2080901@sandisk.com> <1424476807.1477.52.camel@haakon3.risingtidesystems.com> <54ED8B38.10904@sandisk.com> <1425074315.30923.74.camel@haakon3.risingtidesystems.com> <54F1ADAF.90808@sandisk.com> <1425279574.13530.53.camel@haakon3.risingtidesystems.com> <54F6DD3B.4030207@sandisk.com> <20150305132337.GA32341@infradead.org> <54F87F17.30207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54F87F17.30207@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/05/2015 08:06 AM, Bart Van Assche wrote:

> If we would do what Nic proposed - modify SCST such that it uses
> configfs instead of sysfs - then that would result in the removal of at
> least one SCST feature that is important to its users, namely automatic
> population of the configuration filesystem with hardware target port
> information. Apparently Nic does not want to convert LIO from configfs
> to sysfs.

Clearly configfs is here to stay, but is there anything that says LIO 
couldn't have both? Besides the issue at hand, there are some other bits 
of useful info in LIO that aren't available because of configfs' 
limitations, but that would be possible via sysfs.

-- Andy
