From: ael <law_ence.dev@ntlworld.com>
Subject: Re: st.c block limits
Date: Thu, 01 Aug 2002 23:51:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D49BB59.2020405@ntlworld.com>
References: <002001c2395d$6e842150$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: linux-scsi@vger.kernel.org

Tony Battersby wrote:
>>>># tar -cf /dev/ntape blah_home.tar.bz2; mt  tell
>>>
> 
>>The tape has a real 10GB capacity. (I believe.)  The 20BG
>>blocks is correct
>>for the default block size of 512. So compression is not an
>>issue here. And
>>the report above is actually 17.8/2 = 8.9 GB :-(
> 
> 
> Some compression algorithms will actually expand data by a significant
> amount.  For example, many implementations of ALDC compression will give a
> compression ratio of 0.8 on random data.  In your example above you are
> writing a .bz2 file (which is already compressed), so it would probably
> expand if compressed again.  Try turning drive internal compression off:
> 
> mt -f /dev/ntape compression off
> 
> This might help squeeze a little more data on your tape.

Thanks for the suggestion. Various such thoughts had crossed what passes 
for my mind, including whether 10GB was before formatting. But I did assume 
that the tape drive/driver was reporting actual bytes on the tape 
regardless of compression.

I was indeed recording largely bz2 files, and I did realize that the 
default drive streaming compression would almost certainly expand again. I 
sometimes do remember to turn the drive compression off in such 
circumstances. But as I say, I assume that the actual data on the tape 
after compression was being reported. That has always seemed to be the case 
in the past, although I am not sure whether I checked very thoroughly.

I guess that I should browse the Imation web site and see exactly they 
specify for the tape itself. The packaging is clearly marked 10GB 
uncompressed. The drive has a read-while-write-and-rerecord-on-error 
circuit, but the tapes have not had much use, and I don't think that the
data is being expanded by repeated blocks. I could be wrong, of course.
And in any case, I would expect the drive to report the total blaoc count 
including repeats.

ael





