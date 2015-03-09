From: Andy Grover <agrover@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Mon, 09 Mar 2015 09:51:57 -0700
Message-ID: <54FDCFAD.8000503@redhat.com>
References: <54B7E70C.8020304@sandisk.com>	 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>	 <54E7112F.2080901@sandisk.com>	 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>	 <54ED8B38.10904@sandisk.com>	 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>	 <54F1ADAF.90808@sandisk.com>	 <1425279574.13530.53.camel@haakon3.risingtidesystems.com>	 <54F6DD3B.4030207@sandisk.com> <20150305132337.GA32341@infradead.org>	 <54F87F17.30207@sandisk.com> <54F8A2B0.70202@redhat.com>	 <54F9565A.2080103@sandisk.com> <54F9FCEB.3080806@redhat.com> <1425709556.15055.42.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1425709556.15055.42.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/06/2015 10:25 PM, Nicholas A. Bellinger wrote:

>>   That's what I was getting at above: configfs works great for
>> exactly what we're using it for, but there are other things sysfs does
>> better so we may want to use both.

> Just posted a small series for allowing fabric drivers to expose
> this using a new 'dynamic_session' TPG attribute, so that user-space
> can optionally perform dynamic -> explicit se_node_acl conversion.
<snip>
> However, given iSCSI IQNs are on average ~64 bytes (max 224 bytes),
> that is still enough for listing 64 (or 18 worst case) sessions
> created by dynamically generated se_node_acls .

Nick thanks for implementing the support for listing dynamic ACLs via 
configfs. This will come in handy, ACK. I'll follow up separately on the 
broader use-both-sysfs-and-configfs question I had.

Regards -- Andy
