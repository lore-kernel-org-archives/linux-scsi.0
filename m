From: Ric Wheeler <rwheeler@redhat.com>
Subject: [LSF/MM TOPIC] really large storage sectors - going beyond 4096 bytes
Date: Tue, 21 Jan 2014 22:04:29 -0500
Message-ID: <52DF353D.6050300@redhat.com>
References: <20131220093022.GV11295@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20131220093022.GV11295@suse.de>
Sender: owner-linux-mm@kvack.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

One topic that has been lurking forever at the edges is the current 4k 
limitation for file system block sizes. Some devices in production today and 
others coming soon have larger sectors and it would be interesting to see if it 
is time to poke at this topic again.

LSF/MM seems to be pretty much the only event of the year that most of the key 
people will be present, so should be a great topic for a joint session.

Ric

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
